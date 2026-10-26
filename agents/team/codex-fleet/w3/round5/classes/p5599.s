# n=5 model=out iset=I1 prefix14_class=5599
mov S1, P3
cmp S1, P0
cmovge P3, P0
cmovle S1, P0
mov P0, P3
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P0, P2
cmovg P3, P2
cmovg P2, P0
cmp S1, P1
cmovle S2, S1
