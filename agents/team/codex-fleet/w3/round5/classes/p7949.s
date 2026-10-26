# n=5 model=out iset=I1 prefix14_class=7949
cmp P2, P1
mov S0, P2
cmovge S0, P1
cmovl P2, P1
mov S2, S0
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovge P3, S1
cmp S2, P0
cmovge S0, P0
mov S0, P3
cmovle S2, P0
cmp S0, P2
