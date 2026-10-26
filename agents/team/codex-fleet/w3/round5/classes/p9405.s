# n=5 model=out iset=I1 prefix14_class=9405
mov S0, P2
cmp P3, P2
cmovg S0, P3
mov S2, P1
cmovge P3, P2
cmp P0, P1
cmovle S2, P0
cmovl P0, P1
cmp P3, S2
cmovg S1, P3
cmovg P3, S2
cmovg S2, S1
mov P2, S2
cmp S0, P0
