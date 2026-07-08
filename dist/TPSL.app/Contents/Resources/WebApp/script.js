document.addEventListener("DOMContentLoaded", () => {
  // ---- Utilities ----
  const MAX_CALC_VALUE = Number.MAX_SAFE_INTEGER / 100;
  const priceFormatter = new Intl.NumberFormat("en", {
    maximumFractionDigits: 2,
    minimumFractionDigits: 0
  });

  const sanitizeNumber = (value, min = 0, max = MAX_CALC_VALUE) => {
    const trimmed = String(value).trim();
    if (!trimmed) return min;

    const numericValue = Number(trimmed);
    if (!Number.isFinite(numericValue)) return min;

    return Math.min(Math.max(numericValue, min), max);
  };

  const roundCurrency = (x, dp = 2) => {
    if (!Number.isFinite(x)) return 0;
    const m = Math.pow(10, dp);
    return Math.round((x + Number.EPSILON) * m) / m;
  };

  const formatPrice = (value) => priceFormatter.format(sanitizeNumber(value));

  // ---- Elements ----
  const inputs = {
    takeProfitPercent: document.getElementById("takeProfitPercent"),
    stopLossPercent: document.getElementById("stopLossPercent"),
    unitPrice: document.getElementById("unitPrice")
  };

  const form = document.getElementById("calculatorForm");
  const quickStopLossButtons = [...document.querySelectorAll("[data-stop-loss]")];
  const resetButton = document.getElementById("resetButton");

  const outputs = {
    takeProfitPrice: document.getElementById("takeProfitPrice"),
    stopLossPrice: document.getElementById("stopLossPrice")
  };

  // ---- Helpers ----

  function normalizeInput(el) {
    el.value = String(sanitizeNumber(el.value));
  }

  function updateQuickStopLossButtons() {
    const currentStopLoss = sanitizeNumber(inputs.stopLossPercent.value);

    quickStopLossButtons.forEach((button) => {
      const optionValue = sanitizeNumber(button.dataset.stopLoss);
      const isSelected = optionValue === currentStopLoss;

      button.classList.toggle("is-selected", isSelected);
      button.setAttribute("aria-pressed", String(isSelected));
    });
  }

  // ---- Core calculation ----
  function calculate() {
    const tpPct = sanitizeNumber(inputs.takeProfitPercent.value);
    const slPct = sanitizeNumber(inputs.stopLossPercent.value);
    const unitPrice = sanitizeNumber(inputs.unitPrice.value);

    const takeProfitPrice = roundCurrency(unitPrice * (1 + tpPct / 100), 2);
    const stopLossPrice = roundCurrency(unitPrice * (1 - slPct / 100), 2);

    outputs.takeProfitPrice.textContent = formatPrice(takeProfitPrice);
    outputs.stopLossPrice.textContent = formatPrice(stopLossPrice);
    updateQuickStopLossButtons();
  }

  // ---- Wire up events ----
  Object.values(inputs).forEach((el) => {
    // live update
    el.addEventListener("input", calculate);
    el.addEventListener("change", calculate);

    el.addEventListener("blur", () => {
      normalizeInput(el);
      calculate();
    });
  });

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    calculate();
  });

  resetButton.addEventListener("click", () => {
    form.reset();
    calculate();
    inputs.unitPrice.focus();
  });

  quickStopLossButtons.forEach((button) => {
    button.addEventListener("click", () => {
      inputs.stopLossPercent.value = button.dataset.stopLoss;
      calculate();
      inputs.stopLossPercent.focus();
    });
  });

  document.addEventListener("keydown", (event) => {
    if (event.key !== "Escape") return;

    event.preventDefault();
    inputs.unitPrice.value = "";
    calculate();
    inputs.unitPrice.focus();
  });

  // ---- Initial run and initial focus ----
  calculate();

  // Slight delay: mimic tabbing behaviour / autoresume focus
  setTimeout(() => {
    inputs.unitPrice.focus();
  }, 1000);

  const canUseServiceWorker =
    "serviceWorker" in navigator &&
    window.isSecureContext &&
    ["http:", "https:"].includes(window.location.protocol);

  if (canUseServiceWorker) {
    navigator.serviceWorker
      .register("./sw.js")
      .then((registration) => registration.update())
      .catch(() => {
        // The calculator still works without offline caching.
      });
  }
});
