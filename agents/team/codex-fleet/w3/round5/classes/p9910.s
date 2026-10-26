# n=5 model=out iset=I1 prefix14_class=9910
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovge P3, S0
mov S0, P2
cmp P2, P0
mov S1, P3
cmovle S0, P0
cmovg P2, P0
cmp S0, S1
cmovl P3, S0
cmovge S1, S0
cmp P2, P1
cmovg S2, P2
