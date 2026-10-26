# n=5 model=out iset=I1 prefix14_class=5690
mov S2, P1
cmp S2, P0
mov S0, P2
cmovge P1, P0
cmovge P0, S2
cmp P2, P3
mov S1, P1
cmovge P2, P3
cmovg P3, S0
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
cmp P3, P0
cmovge S2, P3
