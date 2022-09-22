import pandas as pd


def is_ascii(s):
    """Check if the characters in string s are in ASCII, U+0-U+7F."""
    return isinstance(s, str) and len(s) == len(s.encode())


def fake_real(row):
    """Map numerical label to fake-real string"""
    label = row["label"]
    if label == 1:
        return "fake"
    else:
        return "real"


if __name__ == '__main__':
    # Load Dataframe
    df = pd.read_csv('fake-news.csv')

    # Filter non-ascii titles
    filtered = df[df['title'].map(is_ascii)].copy()

    # Assign readable labels
    filtered['reliability'] = df.apply(lambda row: fake_real(row), axis=1)

    # Save it
    filtered.to_json("fake-news-filtered.json", orient="records")
    filtered.to_csv("fake-news-filtered.csv")
