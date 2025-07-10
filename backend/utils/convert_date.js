const convertDate = (str) => {
  const parts = str.split("/");
  if (parts.length !== 3) {
    throw new Error("Ngày không đúng định dạng dd/mm/yyyy");
  }

  const [day, month, year] = parts;
  return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
};
module.exports = convertDate;
