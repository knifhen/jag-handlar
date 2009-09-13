package api

import groovy.xml.MarkupBuilder

/**
 * Created by IntelliJ IDEA.
 * User: knifhen
 * Date: Sep 13, 2009
 * Time: 2:15:46 PM
 * To change this template use File | Settings | File Templates.
 */
class ApiResults {

  def static getLoginAsTeacherResult(String usernameString, String apikeyString, String statusString) {
    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)
    xml.result() {
      status(statusString)
      username(usernameString)
      apikey(apikeyString)
    }
    return writer.toString()
  }

  def static getAnswersResult(String studentString, String bookString, answerList) {
    def writer = new StringWriter()
    def xml = new MarkupBuilder(writer)

    xml.result() {
      student(studentString)
      book(bookString)
      answers() {
        for (answerInstance in answerList) {
          answer() {
            question_key(answerInstance.question_key)
            answer(answerInstance.answer)
          }
        }
      }
      
    }


    return writer.toString()
  }
}
