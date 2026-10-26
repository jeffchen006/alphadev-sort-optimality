# n=5 model=out iset=I1 prefix14_class=9177
cmp P1, P3
cmovge S2, P3
cmovg P3, P1
cmovle S2, P1
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
mov P1, S2
cmp P1, P2
mov S1, P3
cmovg S2, P2
cmovge P2, P1
mov S2, P2
