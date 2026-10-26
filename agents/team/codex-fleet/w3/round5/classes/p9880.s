# n=5 model=out iset=I1 prefix14_class=9880
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovle P1, P0
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
cmovl P3, S0
mov S2, P2
cmp S1, P2
mov P0, P1
cmovle S2, S1
cmovg P2, S1
cmp P3, P1
