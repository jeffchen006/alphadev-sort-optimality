# n=5 model=out iset=I1 prefix14_class=1816
cmp P0, P3
cmovge S0, P3
mov S2, P2
cmovge P3, P0
cmovg P0, S0
cmp P1, P2
cmovg P2, P1
cmovg P1, S2
cmp P3, P2
mov S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P1, P0
mov S1, P0
