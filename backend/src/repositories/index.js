import env from '../config/env.js';

const { DB_DRIVER } = env;

const repoMap = {
    mongo: {
        UserRepository: './mongo/user_repo.js',
        OtpRepository: './mongo/otp_repo.js',
        NotificationRepository: './mongo/notification_repo.js',
        VehicleRepository: './mongo/vehicle_repo.js',
        BrandRepository: './mongo/brand_repo.js',
        BookingRepository: './mongo/booking_repo.js',
        ReviewRepository: './mongo/review_repo.js',
        ReviewReportRepository: './mongo/review_report_repo.js',
        BannerRepository: './mongo/banner_repo.js',
        DeviceRepository: './mongo/device_repo.js',
        TelemetryActiveRepository: './mongo/telemetry_active_repo.js',
        TelemetryRawRepository: './mongo/telemetry_raw_repo.js'

    },
    mysql: {
    }
};

export default async function getRepositories() {
    if (!repoMap[DB_DRIVER]) {
        throw new Error("DB_DRIVER invalid");
    }

    const repos = {};
    const repoDefs = repoMap[DB_DRIVER];

    for (const [name, path] of Object.entries(repoDefs)) {
        const { default: RepoClass } = await import(path);
        repos[name] = new RepoClass();
    }
    return repos;
};
