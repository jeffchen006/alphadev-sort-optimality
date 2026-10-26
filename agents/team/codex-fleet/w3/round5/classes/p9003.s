# n=5 model=out iset=I1 prefix14_class=9003
mov S2, P0
mov S1, P1
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmp S1, P2
cmovge P1, P2
cmovge P2, S1
cmovg S1, P1
mov P2, S1
mov S0, S2
