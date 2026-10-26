# n=5 model=out iset=I1 prefix14_class=8723
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov S1, P0
cmovg P3, S2
cmp S1, P1
cmovle P0, P1
cmovle P1, S1
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovg P3, P0
mov P0, P1
mov S1, S0
