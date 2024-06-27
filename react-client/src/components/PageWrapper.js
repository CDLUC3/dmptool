import React, { ReactNode, useEffect } from 'react';

function PageWrapper(props) {
    useEffect(() => {
        document.title = `${props.title} | DMPTool`;
        window.scrollTo(0, 0);
    }, [props.title]);
    return <>{props.children}</>;
}

export default PageWrapper;