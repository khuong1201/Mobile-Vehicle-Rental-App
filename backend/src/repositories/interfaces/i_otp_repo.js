import IRepo from "./i_repo.js";
export default class IOtpRepo extends IRepo {
    async findValidOtp(userIdentifier){ throw new Error("Not implemented"); }
}
