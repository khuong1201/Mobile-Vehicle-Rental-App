import IRepo from "./i_repo.js";

export default class INotificationRepository extends IRepo {
    async markAsSent(id, providerMessageId) { throw new Error("Not implemented"); }
    async markAsFailed(id, errorMessage) { throw new Error("Not implemented"); }
}