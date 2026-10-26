# n=5 model=out iset=I1 prefix14_class=12342
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovle P1, P2
mov S2, P0
cmp P3, S2
cmovg S2, P3
cmovg P3, P0
cmp S0, P3
cmovge S1, S0
cmovg S0, P3
cmovg P3, S1
mov P2, P1
cmp P1, S2
