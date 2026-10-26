# n=5 model=out iset=I1 prefix14_class=1024
mov S1, P3
cmp S1, P1
cmovl S1, P1
mov S0, P0
cmovl P1, P3
cmp P0, P2
mov P3, S1
cmovge P0, P2
cmovg P2, S0
cmp P2, S1
cmovge P3, P2
cmovg P2, S1
cmp P0, P1
cmovle S0, P1
