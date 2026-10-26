# n=5 model=out iset=I1 prefix14_class=12182
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
mov S0, P0
cmp P3, P0
cmovle S0, P3
cmovge P0, P3
cmp S0, P2
cmovl S1, S0
cmovle S0, P2
cmovl P2, S1
cmp P0, S2
mov P2, S2
