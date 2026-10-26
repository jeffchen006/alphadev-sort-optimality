# n=5 model=out iset=I1 prefix14_class=9426
mov S0, P1
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovl P2, S2
cmp P0, S0
cmovg S0, P0
cmovge P0, P1
cmovl P1, P0
cmp P1, P3
mov S1, S0
cmovg P1, P3
cmovge P3, P0
mov P0, P3
