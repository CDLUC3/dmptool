import {
  Link,
  useParams,
  useNavigate,
} from 'react-router-dom';

import {
  useEffect,
  useState,
} from 'react';

import { DmpApi } from '../../../api.js';


import TextInput from '../../../components/text-input/textInput';
import RadioButton from '../../../components/radio/radio';


function PlanFunders() {
  let navigate = useNavigate();
  const { dmpId } = useParams();
  const [dmp, setDmp] = useState({});





  const [hasFunder, sethasFunder] = React.useState("true") // 0: no show, 1: show yes, 2: show no.

  console.log('ddd');
  const handleOptionChange = (e) => {

  };





  useEffect(() => {
    let api = new DmpApi();
    fetch(api.getPath(`/dmps/${dmpId}`)).then((resp) => {
      api.handleResponse(resp);
      return resp.json();
    }).then((data) => {
      setDmp(data.items[0].dmp);
    });
  }, [dmpId]);




  async function handleSave(ev) {
    ev.preventDefault();
    let api = new DmpApi();

    // Collect the form data
    var stepData = {};
    const form = ev.target;
    const formData = new FormData(form);

    formData.forEach((value, key) => stepData[key] = value);

    console.log('DMPS?');
    console.log(dmp);

    console.log('Step Data');
    console.log(stepData);

    console.log(`/dashboard/dmp/${dmpId}/project-search`);

    navigate(`/dashboard/dmp/${dmpId}/project-search`);







    // TODO:: Add the funder to the DMP data
    // This is the expected structure to add to the DMP
    //
    // NOTE:: This data will come from the Funder typeahead input field.
    //
    // {
    //   "project": [{
    //     "funding": [
    //       {
    //         "dmproadmap_project_number": "prj-XYZ987-UCB",
    //         "grant_id": {
    //           "type": "other",
    //           "identifier": "776242"
    //         },
    //         "name": "National Science Foundation",
    //         "funder_id": {
    //           "type": "fundref",
    //           "identifier": "501100002428"
    //         },
    //         "funding_status": "granted",
    //         "dmproadmap_opportunity_number": "Award-123"
    //       }
    //     ]
    //   }]
    // }

    let options = api.getOptions({
      method: "put",
      body: JSON.stringify({ "dmp": dmp }),
    });

    // fetch(api.getPath('/dmps'), options).then((resp) => {
    //   api.handleResponse(resp.status);
    //   return resp.json();
    // }).then((data) => {
    //   let dmp = data.items[0].dmp;
    //   navigate(`/dashboard/dmp/${dmpId}`);
    // });
  }

  return (
    <>
      <div id="funderPage">

        <div className="dmpui-heading">
          <h1>Funder</h1>
        </div>




        <form method="post" enctype="multipart/form-data" onSubmit={handleSave}>

          <div className="form-wrapper">




            <div className="dmpui-form-cols">


              <div className="dmpui-form-col">
                <div
                  className={'dmpui-field-group'}
                >
                  <label className="dmpui-field-label">
                    Do you have a funder?
                  </label>
                  <p className="dmpui-field-help">
                    Is there a funder associated with this project?
                  </p>



                  <RadioButton
                    label="No"
                    name="have_funder"
                    id="have_funder_no"
                    value="false"
                    inputValue="false"

                    onClick={(e) => handleOptionChange("false")}
                  />

                  <RadioButton
                    label="Yes, I have a funder"
                    name="have_funder"
                    id="have_funder_yes"
                    inputValue="true"
                    value="true"
                    checked="checked"

                    onClick={(e) => handleOptionChange("true")}

                  />



                </div>
              </div>
            </div>





            <div className="dmpui-form-cols">
              <div className="dmpui-form-col">
                <TextInput
                  label="Funder Name"
                  type="text"
                  name="funder_not_listed"
                  id="funder_not_listed"
                  placeholder=""
                  help=""
                  inputValue="test"
                  error=""
                />
                <div className="dmpui-field-checkbox-group not-listed">

                  <input id="id_funder_not_listed"
                    className="dmpui-field-input-checkbox"
                    name="funder_not_listed"
                    value="true"
                    type="checkbox" />
                  <label htmlFor="id_funder_not_listed" className="checkbox-label">
                    My funder isn't listed
                  </label>
                </div>
              </div>
            </div>




          </div>

          <div className="form-actions ">
            <button type="button" onClick={() => navigate(-1)}>Cancel</button>
            <button type="submit" className="primary">Save &amp; Continue</button>
          </div>
        </form>



      </div>
    </>
  )
}

export default PlanFunders;
