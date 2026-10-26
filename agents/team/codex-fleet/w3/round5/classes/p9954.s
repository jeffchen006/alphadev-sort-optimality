# n=5 model=out iset=I1 prefix14_class=9954
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovge S0, P1
cmp P3, P2
cmovge P1, P3
cmovg P3, P2
cmovg P2, P1
cmp S0, P2
mov S1, S0
cmovg S0, P2
cmovge P2, S1
mov S1, S0
mov P2, P3
