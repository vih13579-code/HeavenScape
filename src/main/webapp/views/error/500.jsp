<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Something Went Wrong | HeavenScape</title>
        <link rel="icon" type="image/png" href="https://res.cloudinary.com/llfxqkny/image/upload/v1787226687/heavenscape/favicon/heavenscape_favicon.png">
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400..800&amp;display=swap" rel="stylesheet">
        <style>
            * { box-sizing: border-box; }
            body { min-height: 100vh; margin: 0; display: grid; place-items: center; padding: 24px; background: #F7F7F8; color: #1B1B1B; font-family: "Be Vietnam Pro", sans-serif; }
            main { width: min(100%, 680px); padding: clamp(32px, 7vw, 64px); border: 1px solid #c5c6ce; border-radius: 8px; background: #fff; box-shadow: 0 18px 48px -36px rgba(4,22,46,.55); text-align: center; }
            .code { color: #5b0503; font-size: 14px; font-weight: 700; letter-spacing: .14em; text-transform: uppercase; }
            h1 { margin: 14px 0 12px; color: #C92127; font-family: "Be Vietnam Pro", Georgia, serif; font-size: clamp(32px, 6vw, 48px); line-height: 1.08; }
            p { margin: 0 auto 28px; max-width: 510px; color: #44474d; line-height: 1.65; }
            a { display: inline-flex; align-items: center; justify-content: center; min-height: 44px; padding: 10px 20px; border-radius: 6px; background: #C92127; color: #fff; font-weight: 700; text-decoration: none; }
            a:hover { background: #8E171B; }
            a:focus-visible { outline: 3px solid rgba(130,146,176,.65); outline-offset: 3px; }
        </style>
    </head>
    <body>
        <main>
            <div class="code">Error 500</div>
            <h1>We hit an unexpected page.</h1>
            <p>The request could not be completed right now. Your data has not been intentionally changed. Please return to HeavenScape and try again.</p>
            <a href="${pageContext.request.contextPath}/home">Return to HeavenScape</a>
        </main>
    </body>
</html>
