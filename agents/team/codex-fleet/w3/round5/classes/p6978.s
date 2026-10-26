# n=5 model=out iset=I1 prefix14_class=6978
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
mov S1, P3
mov S2, P2
cmovg P0, S0
cmp P1, P3
cmovge P3, P1
cmovle S1, P1
cmp S2, P3
cmovg P2, P3
cmovl S2, P3
cmp S1, P0
mov S2, P0
