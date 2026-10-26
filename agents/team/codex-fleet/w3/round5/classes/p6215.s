# n=5 model=out iset=I1 prefix14_class=6215
mov S1, P0
mov S0, P3
cmp S1, P2
cmovl S1, P2
cmovg P0, P2
cmp P1, P3
cmovg S0, P1
cmovle P3, P1
cmp S1, S0
mov S2, S1
cmovle S1, S0
cmovle S0, S2
mov S1, S0
cmp P0, P3
