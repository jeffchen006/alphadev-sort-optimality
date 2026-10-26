# n=5 model=out iset=I1 prefix14_class=8550
cmp P0, P3
mov S2, P0
cmovle P0, P3
mov S0, P2
cmovl P3, S2
cmp P2, P1
cmovge P2, P1
cmovle S0, P1
cmp S0, P0
cmovg S1, S0
cmovge S0, P0
cmovg P0, S1
cmp P2, P3
cmovle S1, P3
