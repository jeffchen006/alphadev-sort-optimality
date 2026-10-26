# n=5 model=out iset=I1 prefix14_class=13642
cmp P3, P1
mov S0, P0
cmovge S1, P1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
cmovge S0, P2
cmovl P0, P2
cmp S1, S0
cmovge P3, S0
cmovge S0, S1
cmovge S1, P3
cmp P0, P1
cmovge P2, P0
