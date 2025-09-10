import asyncHandler from "../middlewares/async_handler.js";

export default class ReviewReportController {
    constructor(reportService) {
        this.reportService = reportService;
        this.createReport = asyncHandler(this.createReport.bind(this));
        this.getReports = asyncHandler(this.getReports.bind(this));
        this.updateReportStatus = asyncHandler(this.updateReportStatus.bind(this));
    }

    async createReport(req, res) {
        const reporterId = req.user.userId;
        const report = await this.reportService.createReport(reporterId, req.body);
        res.status(201).json({ status: "success", data: report });
    }

    async getReports(req, res) {
        const options = {
            sortBy: req.query.sortBy,
            limit: parseInt(req.query.limit) || 10,
            page: parseInt(req.query.page) || 1
        };
        const reports = await this.reportService.getReports(options);
        res.json({ status: "success", results: reports.length, data: reports });
    }
    
    async updateReportStatus(req, res) {
        const reviewReportId = req.params.reviewReportId;
        const status = req.body.status;
        const updatedReport = await this.reportService.updateReportStatus(reviewReportId, status);
        res.json({ status: "success", data: updatedReport });
    }
}