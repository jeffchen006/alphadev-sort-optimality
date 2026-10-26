# n=5 model=out iset=I1 prefix14_class=7656
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S0, P0
cmovg S2, P2
cmp P1, S0
cmovg P0, P1
cmovle S0, P1
cmp S0, P3
cmovge P2, S0
cmovl P2, P3
cmovl P3, S0
cmp P0, S2
cmovle S0, P0
