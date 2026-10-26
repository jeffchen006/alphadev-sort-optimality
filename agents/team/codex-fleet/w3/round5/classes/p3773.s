# n=5 model=out iset=I1 prefix14_class=3773
mov S1, P0
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
mov S2, P3
cmp P1, P3
cmovge P3, P1
cmovge P1, S2
mov P2, S1
cmp S1, P1
cmovle S1, P1
cmovl P1, P2
cmp P0, P3
mov S0, S1
