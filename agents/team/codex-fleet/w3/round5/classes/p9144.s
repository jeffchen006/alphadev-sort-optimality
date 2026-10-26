# n=5 model=out iset=I1 prefix14_class=9144
mov S1, P0
cmp P1, S1
cmovle S1, P1
cmovge P0, P1
mov S0, S1
cmp P3, P2
cmovl P1, P2
cmovl P2, P3
cmovl P3, P1
cmp S0, P2
cmovg S0, P2
cmovge P2, S1
cmp P0, P3
mov S1, P2
