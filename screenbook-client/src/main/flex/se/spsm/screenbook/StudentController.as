package se.spsm.screenbook {
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.controls.Alert;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import se.spsm.screenbook.answer.Answer;
import se.spsm.screenbook.answer.AnswerEvent;
import se.spsm.screenbook.apikey.ApiKey;
import se.spsm.screenbook.apikey.ApiKeyRequiredEvent;
import se.spsm.screenbook.student.StudentEvent;
import se.spsm.screenbook.student.StudentResult;

public class StudentController extends EventDispatcher {



    private var settings:ConnectionSettings;

    [Event("ApiKeyRequiredEvent.REQUIRED")]

    public function StudentController(settings:ConnectionSettings) {
        this.settings = settings;
    }

    private function studentCreatedResult(e:ResultEvent):void {
        var result:StudentResult = new StudentResult(XML(e.result));
        var event:Event = new StudentEvent(StudentEvent.STUDENT_CREATED, result);
        dispatchEvent(event);
    }

    private function studentBookOpenedResult(e:ResultEvent):void {
        var result:StudentResult = new StudentResult(XML(e.result));
        var event:Event = new StudentEvent(StudentEvent.BOOK_OPENED, result);
        dispatchEvent(event);
    }

    private function httpServiceFault(e:FaultEvent):void {
        // TODO remove alert
        Alert.show("Problem due to " + e.toString());
        throw new Error("There was a problem sending the request due to: " + e.toString());
    }

    public function createStudent(apiKey:ApiKey, student:String, screenKeyboard:Boolean):void {
        if (!checkApiKey(apiKey)) {
            return;
        }


        var service:HTTPService = settings.createService("api/createStudent");

        var params:Object = apiKey.toParameters();
        params.student = student;
        params.screenKeyboard = screenKeyboard;


        service.addEventListener(ResultEvent.RESULT, studentCreatedResult);
        service.addEventListener(FaultEvent.FAULT, httpServiceFault);

        service.send(params);

    }

    private function checkApiKey(apiKey:ApiKey):Boolean {
        if (apiKey == null) {
            dispatchEvent(new ApiKeyRequiredEvent());
            return false;
        }

        return true;
    }

    public function openBookAsStudent(apiKey:ApiKey, student:String):void {
        if (!checkApiKey(apiKey)) {
            return;
        }


        var service:HTTPService = settings.createService("api/openBookAsStudent");

        var params:Object = apiKey.toParameters();
        params.student = student;


        service.addEventListener(ResultEvent.RESULT, studentBookOpenedResult);
        service.addEventListener(FaultEvent.FAULT, httpServiceFault);

        service.send(params);
    }


    public function saveAnswer(apiKey:ApiKey, student:String, question:String, answer:String):void {
        if (!checkApiKey(apiKey)) {
            return;
        }

        var service:HTTPService = settings.createService("api/saveAnswer");

        var params:Object = apiKey.toParameters();
        params.student = student;
        params.book = "jag-handlar";
        params.question_key = question;
        params.answer = answer;

        service.addEventListener(ResultEvent.RESULT, onAnswerSaved);
        service.addEventListener(FaultEvent.FAULT, httpServiceFault);

        service.send(params);
    }

    private function onAnswerSaved(e:ResultEvent):void {
        dispatchEvent(new AnswerEvent(AnswerEvent.SAVED, new Answer().fromXml(XML(e.result))));
    }

    public function loadAnswer(apiKey:ApiKey, student:String, question:String):void {
        if (!checkApiKey(apiKey)) {
            return;
        }

        var service:HTTPService = settings.createService("api/loadAnswer");

        var params:Object = apiKey.toParameters();
        params.student = student;
        params.question_key = question;
        params.book = "jag-handlar";

        service.addEventListener(ResultEvent.RESULT, onAnswerLoaded);
        service.addEventListener(FaultEvent.FAULT, httpServiceFault);

        service.send(params);
    }

    private function onAnswerLoaded(e:ResultEvent):void {
        dispatchEvent(new AnswerEvent(AnswerEvent.LOADED, new Answer().fromXml(XML(e.result))));
    }


}
}