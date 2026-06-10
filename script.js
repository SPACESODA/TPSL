document.addEventListener("DOMContentLoaded", () => {
  // ---- Utilities ----
  const toNum = (v) => {
    const n = parseFloat(v);
    return Number.isFinite(n) ? n : 0;
  };

  const clampMin = (value, min = 0) => Math.max(min, value);

  const round = (x, dp = 2) => {
    const m = Math.pow(10, dp);
    return Math.round((x + Number.EPSILON) * m) / m;
  };

  const formatPrice = (value) =>
    new Intl.NumberFormat("en", {
      maximumFractionDigits: 2,
      minimumFractionDigits: 0
    }).format(value);

  // ---- Elements ----
  const inputs = {
    takeProfitPercent: document.getElementById("takeProfitPercent"),
    stopLossPercent: document.getElementById("stopLossPercent"),
    unitPrice: document.getElementById("unitPrice")
  };

  const form = document.getElementById("calculatorForm");
  const resetButton = document.getElementById("resetButton");

  const outputs = {
    takeProfitPrice: document.getElementById("takeProfitPrice"),
    stopLossPrice: document.getElementById("stopLossPrice")
  };

  // ---- Helpers ----

  // Handle blank input on blur (for other numeric fields)
  function handleBlankInput(el, fallback = "0") {
    if (!el.value.trim()) {
      el.value = fallback;
    }
  }

  // ---- Core calculation ----
  function calculate() {
    const tpPct = clampMin(toNum(inputs.takeProfitPercent.value));
    const slPct = clampMin(toNum(inputs.stopLossPercent.value));
    const unitPrice = clampMin(toNum(inputs.unitPrice.value));

    const takeProfitPrice = round(unitPrice * (1 + tpPct / 100), 2);
    const stopLossPrice = clampMin(round(unitPrice * (1 - slPct / 100), 2));

    outputs.takeProfitPrice.textContent = formatPrice(takeProfitPrice);
    outputs.stopLossPrice.textContent = formatPrice(stopLossPrice);
  }

  // ---- Wire up events ----
  Object.values(inputs).forEach((el) => {
    // live update
    el.addEventListener("input", calculate);
    el.addEventListener("change", calculate);

    el.addEventListener("blur", () => {
      handleBlankInput(el);
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
    navigator.serviceWorker.register("./sw.js").catch(() => {
      // The calculator still works without offline caching.
    });
  }
});
