import { FC } from "react";
import Link from "next/link";
import Typography from "@mui/material/Typography";
import Container from "@mui/material/Container";
import Button from "@mui/material/Button";

const NotFound: FC = () => {
  return (
    <Container
      sx={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "middle",
        textAlign: "center",
      }}
    >
      <Typography component="h1" variant="h4">
        404: Not Found
      </Typography>
      <Typography variant="body1" sx={{ mt: 4 }}>
        指定のURLのページは見つかりませんでした。
        <Link href="/" passHref>
          <Button>Home</Button>
        </Link>
      </Typography>
    </Container>
  );
};

export default NotFound;
