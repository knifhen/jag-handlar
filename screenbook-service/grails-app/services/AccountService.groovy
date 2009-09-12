class AccountService {

    def authenticateService

    boolean transactional = true

    def createMainAccount(String username) {
      log.info("Creating account " + username)

      //TODO Set correct password
      def account = new Account(username: username, passwd: authenticateService.encodePassword("aaa"), enabled: true)
      account.save()

      // TODO Teachers should not be admins
      Role.findByAuthority("ROLE_ADMIN").addToPeople(account)
      
      return account
    }

	def verifyLogin(String username, String password) {
		def account = Account.findByUsername(username);
		return account != null && account.passwd == authenticateService.encodePassword(password)
	}

  /**
    * Change password without checking previous password. This method should not be exposed to end users.
   */
    def setNewPassword(String accountName, String newPassword) {
       if (!mainAccountExists(accountName)) {
         log.warn("Could not find account ${accountName} when setting new password.");
         return;
       }

       def account = Account.findByUsername(accountName);
       account.passwd = authenticateService.encodePassword(newPassword);
    }

	/**
	 * Check if the student account exists and that it is possible to login
	 */
	def verifyStudentLogin (String mainAccountName, String studentAccountName) {
		return Student.findByUsernameAndMainAccount(studentAccountName, mainAccountName) != null
	}

	def verifyFreeLicences (String mainAccountName) {
		log.info("Verifying free licenses for " + mainAccountName)
		def account = Account.findByUsername(mainAccountName)

        if (account == null) {
            log.warn("Could not find account ${mainAccountName}");
            return false;
        }

		return account.hasFreeLicenses()
	}

    def mainAccountExists(String mainAccountName) {
        def account = Account.findByUsername(mainAccountName)
        return account != null;
    }

    def createStudentAccount(String mainAccountName, String studentAccountName) {
      log.info("Creating student " + studentAccountName)

	  def account = Account.findByUsername(mainAccountName)

      def student = new Student(username: studentAccountName, account: account)
      student.save()

      return student
    }

}
