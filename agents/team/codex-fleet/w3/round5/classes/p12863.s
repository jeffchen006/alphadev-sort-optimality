# n=5 model=out iset=I1 prefix14_class=12863
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P3, P0
mov S1, P3
cmovle P3, P0
cmovg S1, P0
mov S0, P2
cmp S0, S1
cmovg P2, S1
cmovle S0, S1
mov P2, S0
mov P0, P1
