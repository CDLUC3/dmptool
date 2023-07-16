import {
  useState,
  useEffect,
} from "react";

function TextArea(props) {
  const [inputType] = useState(props.type);
  const [inputValue, setInputValue] = useState(props.inputValue);

  useEffect(() => {
    setInputValue(props.inputValue)
  }, [props.inputValue]);

  function handleChange(event) {
    const newValue = event.target.value;
    setInputValue(newValue);
    if (props.onChange) props.onChange(newValue);
  }

  let errorMsg = props?.error ? props.error : "";
  let errorClass = "";
  if (errorMsg) {
    errorClass = "has-error";
    errorMsg = errorMsg;
  }

  return (
    <>
      <div className={"dmpui-field-group " + errorClass}>
        <label className="dmpui-field-label">
          {props?.label ? props.label : ""}
        </label>
        <p className="dmpui-field-help">{props?.help ? props.help : ""}</p>

        {errorMsg && <p className="dmpui-field-error"> {errorMsg} </p>}

        <div className="dmpui-field-input-group">
          <textarea
            type={inputType}
            name={props?.name ? props.name : ""}
            id={props?.id ? props.id : ""}
            onChange={handleChange}
            placeholder={props?.placeholder}
            autoComplete={props?.autocomplete ? props.autocomplete : "off"}
            className="dmpui-field-input-textarea"
          >
            {inputValue}
          </textarea>
        </div>
      </div>
    </>
  );
}

export default TextArea;