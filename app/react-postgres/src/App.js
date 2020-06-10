import React, {useState, useEffect} from 'react';

function App() {
  const [result, setRes] = useState(false);
  useEffect(() => {
    getViewer();
  }, []);
  
  function printer(el) {
    let finStr = "";
        for (let [key, value] of Object.entries(el)) {
          finStr += `${key}: ${value}\n`;
        }
    return finStr;   
}

  
  function getViewer() {
    fetch('http://localhost:3001/getViewers')
      .then(response => {
        return response.text();
      })
      .then(data => {
        setRes(data);
      });
  }

  let get_table = (id) => {
    fetch(`http://localhost:3001/table/${id}`)
    .then(response => {
      return response.text();
    })
    .then(data => {
      setRes(data);
    });
  }

  function createViewer() {
    let v_name = prompt('Enter viewer name');
    let v_login = prompt('Enter viewer login');
    let v_password = prompt('Enter viewer password');
    let v_permission = prompt('Enter viewer permission (lord/viewer)');
    if (!(v_name && v_login && v_password && v_permission)){return;}
    fetch('http://localhost:3001/createViewers', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({v_name, v_login, v_password, v_permission}),
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        alert(data);
        getViewer();
        // getViewer();
      });
  }
  function deleteViewer() {
    let id = prompt('Enter viewer id');
    if (!id) {return;}
    fetch(`http://localhost:3001/viewers/${id}`, {
      method: 'DELETE',
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        
        alert(data);
        getViewer();
      })
  }

  function e_take() {
    let bodyObject = {};
    bodyObject["alc_id"] = prompt('Enter alcoholics id');
    bodyObject["inp_id"] = prompt('Enter inspectors id');
    bodyObject["date_entered"] = prompt('Enter entered date. (e.g.2020-03-04)');
    bodyObject["bed_id"] = prompt('Enter bed id');
    if (!(bodyObject["alc_id"] && bodyObject["inp_id"] && bodyObject["date_entered"] && bodyObject["bed_id"])){return;}
    fetch(`http://localhost:3001/event/e_take`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bodyObject),
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        // alert(data);
        get_table(7);
        // getViewer();
      });
  }

  function e_release() {
    let bodyObject = {};
    bodyObject["alc_id"] = prompt('Enter alcoholics id');
    bodyObject["inp_id"] = prompt('Enter inspectors id');
    bodyObject["date_freed"] = prompt('Enter freed date (e.g.2020-03-04)');
    if (!(bodyObject["alc_id"] && bodyObject["inp_id"] && bodyObject["date_freed"])){return;}
    fetch('http://localhost:3001/event/e_release', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bodyObject),
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        // alert(data);
        get_table(7);
        // getViewer();
      });
  }

  function e_faint() {
    //(MY_alc_id, MY_date;
    let bodyObject = {};
    bodyObject["alc_id"] = prompt('Enter alcoholics id');
    bodyObject["date_freed"] = prompt('Enter date of faint (e.g.2020-03-04)');
    if (!(bodyObject["alc_id"] && bodyObject["date_freed"])){return;}
    fetch('http://localhost:3001/event/e_faint', {
      method: 'POST', 
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bodyObject),
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        alert(data);
        get_table(3);
        // getViewer();
      });
  }

  function r_alco_took() {
    let bodyObject = {};
    bodyObject["alc_id"] = prompt('Enter alcoholics id');
    bodyObject["date_from"] = prompt('Enter entered date from (e.g.2020-03-04)');
    bodyObject["date_to"] = prompt('Enter entered date to (e.g.2020-03-04)');
    bodyObject["num_of_times"] = prompt('Enter number of times caught');
    if (!(bodyObject["alc_id"] && bodyObject["date_from"] && bodyObject["date_to"] && bodyObject["num_of_times"])){return;}
    fetch(`http://localhost:3001/request/r_alco_took`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(bodyObject),
    })
      .then(response => {
        return response.text();
      })
      .then(data => {
        // alert(data);
        setRes(data);
        // getViewer();
      });
  }

  const newArr = JSON.parse(result);
  return (
    <div>
      {/* {Object.keys(newArr).map((inx) =>(
        <div className="viewer" key={inx}>ID: {newArr[inx].v_id} NAME: {newArr[inx].v_name} LOGIN: {newArr[inx].v_login} PASSWORD: {newArr[inx].v_password} PERMISSION: {newArr[inx].v_permission}</div>
      ))} */}

      {
        Object.keys(newArr).map((inx) =>(
          <div key={inx}>{printer(newArr[inx])}</div>
        ))
      }

      {/* <div>{newArr}</div> */}
      <br />
      <button onClick={getViewer}>Get list of accounts</button>
      <br />
      <button onClick={createViewer}>Create account</button>
      <br />
      <button onClick={deleteViewer}>Delete account</button>
      <br />
      <button onClick={e_take}>Put somebody into jail</button>
      <br />
      <button onClick={e_release}>Take somebody from jail</button>
      <br />
      <button onClick={e_faint}>Make somebody faint</button>
      <br />
      <button onClick={r_alco_took}>How many times officers cauught alcoholic</button>
      <br />


      <button onClick={() => get_table(0)}>Get alcoholic</button>
      <br />
      <button onClick={() => get_table(1)}>Get bed</button>
      <br />
      <button onClick={() => get_table(2)}>Get drink</button>
      <br />
      <button onClick={() => get_table(3)}>Get faints</button>
      <br />
      <button onClick={() => get_table(4)}>Get inspector</button>
      <br />
      <button onClick={() => get_table(5)}>Get party</button>
      <br />
      <button onClick={() => get_table(6)}>Get party_id_alcoholic_id</button>
      <br />
      <button onClick={() => get_table(7)}>Get registry</button>
      <br />
      <button onClick={() => get_table(8)}>Get song</button>
    </div>
  );
}

export default App;