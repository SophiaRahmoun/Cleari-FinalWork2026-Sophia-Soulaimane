const dermatologistCodes = ["550"];

const isDermatologistInami = (inamiNumber) => {
  if (!inamiNumber || inamiNumber.length < 3) {
    return false;
  }

  const code = inamiNumber.slice(-3);
  return dermatologistCodes.includes(code);
};

module.exports = {
  isDermatologistInami,
};