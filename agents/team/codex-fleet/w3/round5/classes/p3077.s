# n=5 model=out iset=I1 prefix14_class=3077
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
cmovg S0, P1
cmovle S0, P0
cmovl P0, P1
cmp S0, P3
mov P1, P0
cmovge S1, S0
cmovg S0, P3
cmovge P3, S1
mov S0, P3
