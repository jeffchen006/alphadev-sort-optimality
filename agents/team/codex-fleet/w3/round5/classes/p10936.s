# n=5 model=out iset=I1 prefix14_class=10936
cmp P1, P2
cmovge S1, P2
cmovle S1, P1
cmovl P1, P2
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
mov P2, P1
cmovg P3, S0
cmp P3, P2
cmovge P2, P3
cmovl P1, P3
cmp S1, P0
cmovl P3, P0
