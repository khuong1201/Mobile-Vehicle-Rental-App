export const bookingTransitions = {
    pending: {
        approved: { role: "owner" },
        rejected: { role: "owner" },
        cancelled: { role: "renter" },
        expired: { role: "system" },
    },
    approved: {
        active: { role: "owner" },
        cancelled: { role: "renter" },
        expired: { role: "system" },
    },
    active: {
        completed: { role: "owner" },
    },
    completed: {},
    rejected: {},
    cancelled: {},
    expired: {},
};