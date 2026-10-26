# n=5 model=out iset=I1 prefix14_class=7182
cmp P2, P0
mov S1, P1
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
mov S0, S1
cmovg P1, P3
cmp P2, P3
cmovge P3, P2
cmovg P2, P1
mov P1, P3
