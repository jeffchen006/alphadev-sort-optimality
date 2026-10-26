# n=5 model=out iset=I1 prefix14_class=252
mov S1, P0
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmovg P1, S0
cmovle S0, P1
cmp P2, P0
cmovge S1, P2
cmovle P0, P2
cmp P0, S0
cmovle S0, P0
cmovl P0, P1
mov S0, P3
cmp S0, S1
