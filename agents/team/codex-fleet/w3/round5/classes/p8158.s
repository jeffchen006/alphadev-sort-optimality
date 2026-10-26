# n=5 model=out iset=I1 prefix14_class=8158
cmp P3, P0
cmovg S2, P3
cmovle S2, P0
cmovle P0, P3
cmp P1, P2
cmovg P3, P1
cmovge P1, P2
cmovg P2, P3
cmp P0, P1
cmovle S0, P0
cmovg S0, P1
cmovg P1, P0
cmp S2, P2
mov S0, P2
