# n=5 model=out iset=I1 prefix14_class=6099
mov S2, P0
mov S0, P3
cmp S2, P1
cmovle S2, P1
cmovle P1, P0
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
mov P0, S0
cmp P0, S2
cmovg S0, S2
cmovg S2, P0
cmp P2, P1
cmovge P3, P1
