from flask import Flask, render_template, request
import json
import emoji

app = Flask(__name__)

@app.route("/", methods=["POST", "GET"]) 
def echo():
    try:
        if request.method == "POST": 
            input_data = request.get_json(force=True)
            interim_data = json.dumps(input_data)
            output_data = json.loads(interim_data)
            animal_text=":{}:".format(output_data["animal"])
            animal_smile=emoji.emojize(":{}:".format(output_data["animal"]))
            if animal_smile!=animal_text:
                animal_smile=animal_smile
            else:
                animal_smile=""
            return render_template("echo.html", data=output_data, animal_smile=animal_smile)
        else:
            return """use POST request with json data in next format:\ncurl -XPOST -d'{"animal":"name_animal","sound":"Myyyy","count":5}' http://localhost\n"""
    except:
        return """use POST request with json data in next format:\ncurl -XPOST -d'{"animal":"name_animal","sound":"Myyyy","count":5}' http://localhost\n"""


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
