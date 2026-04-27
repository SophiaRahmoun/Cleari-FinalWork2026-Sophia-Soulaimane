function simplifySkinAnalysisResults(resultData) {
    const output = resultData?.results?.output || [];
    const simplified = {};
  
    for (const item of output) {
      simplified[item.type] = {
        uiScore: item.ui_score ?? null,
        rawScore: item.raw_score ?? null,
        maskUrls: item.mask_urls ?? []
      };
    }
  
    return simplified;
  }
  
  function estimateSkinType(scores) {
    const oiliness = scores.oiliness?.uiScore ?? 0;
    const moisture = scores.moisture?.uiScore ?? 0;
  
    if (oiliness > 70 && moisture < 50) return "oily";
    if (oiliness < 40 && moisture < 45) return "dry";
    if (oiliness > 55 && moisture >= 45) return "combination";
    return "normal";
  }
  
  function buildRecommendation(scores) {
    const wrinkle = scores.wrinkle?.uiScore ?? 0;
    const redness = scores.redness?.uiScore ?? 0;
    const acne = scores.acne?.uiScore ?? 0;
    const oiliness = scores.oiliness?.uiScore ?? 0;
    const moisture = scores.moisture?.uiScore ?? 0;
  
    let recommendationLevel = "low";
    let shortAdvice =
      "Your skin scan looks generally stable. Keep monitoring changes over time.";
  
    if (redness > 75 || acne > 80) {
      recommendationLevel = "high";
      shortAdvice =
        "Visible skin concerns were detected. Consider seeking professional advice if this persists or worsens.";
    } else if (wrinkle > 70 || oiliness > 75 || moisture < 40) {
      recommendationLevel = "monitor";
      shortAdvice =
        "Moderate concerns were detected. A simple routine and a follow-up scan may be helpful.";
    }
  
    return {
      skinTypeEstimate: estimateSkinType(scores),
      recommendationLevel,
      shortAdvice
    };
  }
  
  module.exports = {
    simplifySkinAnalysisResults,
    buildRecommendation
  };