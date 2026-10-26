# n=5 model=out iset=I1 prefix14_class=3749
cmp P0, P1
mov S1, P1
mov S0, P2
cmovle S1, P0
cmovg P1, P0
cmovge P0, S1
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmp P3, S1
cmovl S1, P3
cmovge P0, P3
mov S1, S0
cmp S0, P1
