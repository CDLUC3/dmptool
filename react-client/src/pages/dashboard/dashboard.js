import { useEffect, useState, Fragment } from "react";
import { useNavigate, Link } from "react-router-dom";

import { DmpApi } from "../../api.js";
import { truncateText } from "../../utils.js";
import { DmpModel } from "../../models.js";
import "./dashboard.scss";
function Dashboard() {
  const [projects, setProjects] = useState([]);
  const [user, setUser] = useState({
    givenname: "",
    surname: "",
  });

  let navigate = useNavigate();

  const [show, setShow] = useState(false);

  function handleQuickViewOpen(id) {
    console.log("Open Modal; Api Load data: ", id);
    setShow(true);
  }

  useEffect(() => {
    let api = new DmpApi();

    fetch(api.getPath("/me"), api.getOptions())
      .then((resp) => {
        api.handleResponse(resp);
        return resp.json();
      })
      .then((data) => {
        setUser(data.items[0]);
      });

    // Fetch the work in progress DMPs for the currently logged in user
    fetch(api.getPath("/drafts"), api.getOptions())
      .then((resp) => {
        api.handleResponse(resp);
        return resp.json();
      })
      .then((data) => {
        console.log(data.items);
        setProjects(data.items);

        // ready to convert to dmp model
        //   const dmpModels = data.items.map((item) => new DmpModel(item.dmp));
        //       setProjects(dmpModels);
      });
  }, []);

  function dmp_id_for(dmp) {
    return dmp.draft_id.identifier;
  }

  return (
    <div id="Dashboard">
      <p>
        Welcome back {user.givenname} {user.surname}
      </p>
      <p>
        <a href="/plans" className="exit-prototype">
          Back to standard Dashboard
        </a>
      </p>

      <div className="dmpui-heading with-action-button">
        <div>
          <h1>Dashboard</h1>
        </div>
        <div>
          <button
            className="primary"
            onClick={() => navigate("/dashboard/dmp/new")}
          >
            Add Plan
          </button>
        </div>
      </div>

      <div className="plan-steps">
        <div className="filter-container">
          <div className="filter-status">
            <h5>Status</h5>
            <div className="filter-quicklinks">
              <a href="/?status=all">All</a>
              <a href="/?status=registered">Registered</a>
              <a href="/?status=incomplete">Incomplete</a>
            </div>
          </div>
          <div className="filter-edited">
            <h5>Edited</h5>
            <div className="filter-quicklinks">
              <a href="/?status=all">All</a>
              <a href="/?status=lastweek">Last week</a>
              <a href="/?status=lastmonth">Last Month</a>
            </div>
          </div>
          <div className="filter-tags">
            <h5>Filter DMPs</h5>
            <button className="button filter-button">Filter</button>
          </div>
          <div className="xcont"></div>
        </div>

        <div class="table-container">
          <div class="table-wrapper">
            <table className="dashboard-table">
              <thead>
                <tr>
                  <th scope="col" className="table-header-name data-heading">
                    <a href="#" className="header-link">
                      Project Name
                    </a>
                  </th>

                  <th scope="col" className="table-header-name data-heading">
                    <a href="#" className="header-link">
                      Funder
                    </a>
                  </th>

                  <th scope="col" className="table-header-name data-heading">
                    <a href="#" className="header-link">
                      Last Edited
                    </a>
                  </th>

                  <th scope="col" className="table-header-name data-heading">
                    <a href="#" className="header-link">
                      Status
                    </a>
                  </th>
                  <th scope="col" className="table-header-name data-heading">
                    <a href="#" className="header-link">
                      Actions
                    </a>
                  </th>
                </tr>
              </thead>
              <tbody className="table-body">
                {projects.map((item) => (
                  <Fragment key={item.dmp.draft_id.identifier}>
                    <tr key={item.dmp.draft_id.identifier}>
                      <td
                        className="table-data-name table-data-title"
                        data-colname="title"
                      >
                        <a
                          title={item.dmp?.title}
                          onClick={() =>
                            handleQuickViewOpen(item.dmp.draft_id.identifier)
                          }
                        >
                          {truncateText(item.dmp?.title, 50)}
                        </a>
                        <a
                          href="#"
                          class="preview-button"
                          onClick={() =>
                            handleQuickViewOpen(item.dmp.draft_id.identifier)
                          }
                        >
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            height="18"
                            style={{ top: "3px", position: "relative" }}
                            viewBox="0 -960 960 960"
                            width="18"
                          >
                            <path d="M433-344v-272L297-480l136 136ZM180-120q-24.75 0-42.375-17.625T120-180v-600q0-24.75 17.625-42.375T180-840h600q24.75 0 42.375 17.625T840-780v600q0 24.75-17.625 42.375T780-120H180Zm453-60h147v-600H633v600Zm-60 0v-600H180v600h393Zm60 0h147-147Z" />
                          </svg>
                        </a>

                        <div className="d-block table-data-pi">
                          PI: {truncateText("John Smith", 50)}
                          {item.dmp.draft_id.identifier &&
                            item.dmp.draft_id.identifier !==
                              "20230629-570ca751fdb0" && (
                              <span className={"action-required-text"}>
                                X works need verification
                              </span>
                            )}
                        </div>
                      </td>
                      <td className="table-data-name" data-colname="funder">
                        <span
                          title={item?.dmp?.project?.[0]?.funding?.[0]?.name}
                        >
                          {truncateText(
                            item?.dmp?.project?.[0]?.funding?.[0]?.name,
                            10
                          )}
                        </span>
                      </td>
                      <td
                        className="table-data-date"
                        data-colname="last_edited"
                      >
                        03-29-2023
                      </td>
                      <td className="table-data-name" data-colname="status">
                        {item?.dmp?.project?.[0]?.status ?? "Incomplete"}
                      </td>
                      <td
                        className="table-data-name table-data-actions"
                        data-colname="actions"
                      >
                        {item.dmp.draft_id.identifier &&
                        item.dmp.draft_id.identifier ===
                          "20230629-570ca751fdb0" ? (
                          <Link
                            className="edit-button"
                            to={`/dashboard/dmp/${item.dmp.draft_id.identifier}`}
                          >
                            Complete
                          </Link>
                        ) : (
                          <Link
                            className="edit-button"
                            to={`/dashboard/dmp/${item.dmp.draft_id.identifier}`}
                          >
                            Update
                            <span className={"action-required"}></span>
                          </Link>
                        )}
                      </td>
                    </tr>
                  </Fragment>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <div
        id="quick-view-modal"
        className={show ? "show" : ""}
        title="Add Contributor"
        onClose={() => setShow(false)}
      >
        <div id="quick-view-backdrop">
          <div id="quick-view-view">
            <div className="quick-view-text-cont">
              <h2>DMP TITLE</h2>
              <h4>Funder</h4>
              <p>National Institute for Health (NIH)</p>
              <h4>GrantID</h4>
              <p>123456-A</p>
              <h4> DMP ID </h4>
              <p>Not set</p>
              <h4>Dates</h4>
              <p>01-05-2020 - 04-04-2021</p>
              <h4>Lead PI(s)</h4>
              <p>John Smith, Robert Edwards, Joe Svensson</p>

              <div className="action-required-validation">
                <h4>Related Works(DOIs)</h4>
                <p>8 related works</p>
                <p>2 Unverified</p>
              </div>

              <h4>Repositories</h4>
              <p>Github</p>
              <h4>Is Public</h4>
              <p>Yes</p>
              <h4>Is Featured</h4>
              <p>No</p>
            </div>

            <div className="form-actions ">
              <button type="submit" className="primary">
                Update
              </button>
              <button type="button" onClick={() => setShow(false)}>
                Close
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
