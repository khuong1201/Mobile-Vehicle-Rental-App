
const Paginate = async (model, query = {}, options = {}) => {
    const {
      page = 1,
      limit = 10,
      sort = { createdAt: -1 },
      populate = [],
      select = null,
    } = options;
  
    const skip = (page - 1) * limit;
  
    const [total, data] = await Promise.all([
        model.countDocuments(query),
        model.find(query)
            .skip(skip)
            .limit(limit)
            .sort(sort)
            .select(select)
            .populate(populate),
    ]);
    return {
        currentPage: page,
        totalPages: Math.ceil(total / limit),
        totalItems: total,
        data,
    };
  };
  
  module.exports = Paginate;
  