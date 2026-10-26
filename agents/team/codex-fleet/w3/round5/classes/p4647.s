# n=5 model=out iset=I1 prefix14_class=4647
mov S2, P1
cmp P0, P1
cmovg P1, P0
mov S1, P3
cmovle S2, P0
cmp P2, P3
cmovle P3, P2
cmovle P2, S1
cmp P2, P1
cmovge P0, P2
cmovge P2, P1
cmovle P0, P1
cmp P3, S2
cmovge P0, P3
