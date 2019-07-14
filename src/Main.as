// Writen by nancheal
// twitter.com/x41x41x41, medium.com/@x41x41x41
// REF: https://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7cfd.html#WS5b3ccc516d4fbf351e63e3d118666ade46-7cb2
package {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class Main extends Sprite {
		private var txtContent:TextField;
		public function Main() {
			txtContent = createCustomTextField(10, 100, 450, 300);
			txtContent.wordWrap = true;
			txtContent.border = true;
			txtContent.background = true;
			txtContent.backgroundColor = 0xFF005A7C;
			txtContent.textColor = 0xFFFFFF;
			txtContent.type= TextFieldType.INPUT;

			// grab DOM from target page
			var get_message_request:URLRequest = new URLRequest("https://bbs.vivo.com.cn/home.php?mod=space&do=pm");
			var message_loader:URLLoader = new URLLoader();
			message_loader.addEventListener(Event.COMPLETE, this.messageHandler);
			try {
				message_loader.load(get_message_request);
			} catch (error: Error) {
				trace("Unable to load URL: " + error);
			}

			var get_formhash_request:URLRequest = new URLRequest("https://bbs.vivo.com.cn/forum.php?mod=viewthread&tid=5532812&page=1#pid218727509");
			var formhash_loader:URLLoader = new URLLoader();
			formhash_loader.addEventListener(Event.COMPLETE, this.formhashHandler);
			try {
				formhash_loader.load(get_formhash_request);
			} catch (error: Error) {
				trace("Unable to load URL: " + error);
			}
			

		}

		private function formhashHandler(event: Event): void {

			// Send data to a place where we can listen for it
			// typically the same webserver that served the flash file			
			var formhash:String = findformhash(event.target.data+"");
			txtContent.appendText("获取到的formhash:" + formhash + "\r\n");
		}

		private function messageHandler(event: Event): void{
			var formhash:String = findmessage(event.target.data+"");
			txtContent.appendText("获取到的message:" + formhash + "\r\n");
		}
		
		private function createCustomTextField(x:Number, y:Number, width:Number, height:Number):TextField {
            var result:TextField = new TextField();
            result.x = x;
            result.y = y;
            result.width = width;
            result.height = height;
            addChild(result);
            return result;
        }

		private function findformhash(str:String):String {
            var pattern:RegExp = /(?<=formhash\" value=\").*?(?=\")/;
            var result:Object = pattern.exec(str);
            if(result == null) {
                return "regx error";
            }
            return result[0];
        }
		private function findmessage(str:String):String {
            var pattern:RegExp = /(?<=\<dd class=\"ptm pm_c\"\>)(.|\n)*?(?=\<\/dd\>)/;
            var result:Object = pattern.exec(str);
            if(result == null) {
                return "用户未登录";
            }
            return result[0];
        }
	}
}