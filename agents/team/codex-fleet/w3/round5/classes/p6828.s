# n=5 model=out iset=I1 prefix14_class=6828
mov S1, P3
cmp P2, P3
cmovle S1, P2
mov S0, P0
cmovl P2, P3
cmp P0, P1
cmovg S0, P1
cmovl P0, P1
mov P3, P0
cmp P2, P3
cmovl P0, P2
cmovl P2, P3
cmp S1, S0
cmovge P2, S1
